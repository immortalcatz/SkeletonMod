package com.fireball1725.skeleton.proxy;

import com.fireball1725.skeleton.Skeleton;
import com.fireball1725.skeleton.client.gui.GuiHandler;
import com.fireball1725.skeleton.common.blocks.Blocks;
import com.fireball1725.skeleton.common.config.Config;
import com.fireball1725.skeleton.common.items.Items;
import com.fireball1725.skeleton.common.util.IProvideEvent;
import com.fireball1725.skeleton.common.util.IProvideRecipe;
import com.fireball1725.skeleton.common.util.IProvideSmelting;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.fml.common.network.NetworkRegistry;

import java.io.File;

public abstract class CommonProxy implements IProxy {
    @Override
    public void registerBlocks() {
        Blocks.registerBlocks();
    }

    @Override
    public void registerItems() {
        Items.registerItems();
    }

    @Override
    public void registerFurnaceRecipes() {
        for (Items item : Items.values()) {
            if (item.getItem() instanceof IProvideSmelting)
                ((IProvideSmelting) item.getItem()).RegisterSmelting();
        }

        for (Blocks block : Blocks.values()) {
            if (block.getBlock() instanceof IProvideSmelting)
                ((IProvideSmelting) block.getBlock()).RegisterSmelting();
        }
    }

    @Override
    public void registerRecipes() {
        for (Items item : Items.values()) {
            if (item.getItem() instanceof IProvideRecipe)
                ((IProvideRecipe) item.getItem()).RegisterRecipes();
        }

        for (Blocks block : Blocks.values()) {
            if (block.getBlock() instanceof IProvideRecipe)
                ((IProvideRecipe) block.getBlock()).RegisterRecipes();
        }
    }

    @Override
    public void registerEvents() {
        for (Items item : Items.values()) {
            if (item.getItem() instanceof IProvideEvent)
                MinecraftForge.EVENT_BUS.register(item.getItem());
        }

        for (Blocks block : Blocks.values()) {
            if (block.getBlock() instanceof IProvideEvent)
                MinecraftForge.EVENT_BUS.register(block.getBlock());
        }
    }

    @Override
    public void registerGUIs() {
        NetworkRegistry.INSTANCE.registerGuiHandler(Skeleton.instance, new GuiHandler());
    }

    @Override
    public void registerRenderers() {
        /** Client Side Only **/
    }

    @Override
    public void registerConfiguration(File configFile) {
        Skeleton.configuration = Config.initConfig(configFile);
    }
}
