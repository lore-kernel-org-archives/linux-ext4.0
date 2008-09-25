From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: vfsmount
Date: Thu, 25 Sep 2008 12:13:24 +0530
Message-ID: <ea11fea30809242343g463c6cebv868d7b0affe7e0cb@mail.gmail.com>
References: <2d08ef090809220957tc397ac5j6cdf110e7cd13f5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:24860 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIYGn2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 02:43:28 -0400
Received: by ti-out-0910.google.com with SMTP id b6so172401tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 24 Sep 2008 23:43:25 -0700 (PDT)
In-Reply-To: <2d08ef090809220957tc397ac5j6cdf110e7cd13f5c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 22, 2008 at 10:27 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> I am interested in getting the vfsmount structure of the mounted file
> system from my module.
> I used filp = get_empty_filp() (filp is file pointer)
> function to create an empty file object (as this contains pointer to
> vfsmount structure)
> file object has a field f_vfsmnt which points to the vfsmount structure
> i am storing this in my own my_vfsmnt structure of type vfsmount.
> my_vfsmnt = filp->f_vfsmnt
> but i am getting my_vfsmnt as NULL ??
>
> is there any other way of getting the vfsmount structure ??

Will this help ??

[root@localhost test]# insmod katiyar.ko
err=0, Path = /
[root@localhost test]# cat nngfs.c
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/mount.h>
#include <linux/namei.h>

#define MOD_AUTHOR "Manish Katiyar"
#define MODULE_DESC "A Simple test module "

static int nngfs_fs_init(void){
        int err;
        struct vfsmount *tmp;
        struct nameidata nd;
        err = path_lookup(".",LOOKUP_FOLLOW | LOOKUP_DIRECTORY,&nd);
        tmp = nd.path.mnt;
        printk(KERN_CRIT "err=%d, Path = %s\n",err,tmp->mnt_root->d_name.name);
        return err;
}

static void nngfs_fs_exit(void){
        printk(KERN_INFO "Unregistering \n");
        return ;
}

module_init(nngfs_fs_init);
module_exit(nngfs_fs_exit);

MODULE_AUTHOR(MOD_AUTHOR);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(MODULE_DESC);


Thanks -
Manish

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
