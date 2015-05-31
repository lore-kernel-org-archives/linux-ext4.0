From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Mon, 1 Jun 2015 01:14:23 +0200
Message-ID: <mkg4kf$429$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54572 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbEaXOb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 19:14:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YzCR2-0003Nl-My
	for linux-ext4@vger.kernel.org; Mon, 01 Jun 2015 01:14:28 +0200
Received: from ip4d14aa5f.dynamic.kabel-deutschland.de ([77.20.170.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 01:14:28 +0200
Received: from for-gmane by ip4d14aa5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 01:14:28 +0200
In-Reply-To: <mkg2u2$ckm$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

U.Mutlu wrote on 06/01/2015 12:45 AM:
> Theodore Ts'o wrote on 05/31/2015 08:59 PM:
>> On Sun, May 31, 2015 at 06:07:38PM +0200, U.Mutlu wrote:
>>> how can a non-root user have a directory of his own, without any root access?
>>> Is this somehow possible, or will it be made possible with the new ext4
>>> (ext5?)?
>>
>> You're not going a lot of details about exactly what the use case you
>> have in mind; are you talking about a non-root user creating a file
>> system which then gets mounted somwhere?  In practice you still need
>> root to do the mount, or at the very least to set up the /etc/fstab to
>> allow a non-root user to mount a file system at a particular mount
>> point.
>>
>> If it's the latter which you are envisioning, then the root_owner
>> extended option to mke2fs(8) may be what you're looking for.
>>
>> If it isn't please go into a much greater detail about what exactly it
>> is you are trying to do, and why.
>
> A private directory (or private mountpoint) for the user only
> (or for an application running under that 'user'-account).
>
> The rationale behind this is: there are many system programs,
> and other programs running with root rights. The user cannot know
> them all and so cannot trust them. This includes also admins and the root user
> itself.
>
> The idea is to have a truly private directory or a private mountpoint
> where by default nobody else has access to it, incl. root,
> unless the owner grants access to others.
>
> Ideal would be if the content therein were encrypted, as is planned
> for the upcoming new ext4-version.
>
> With such a mechanism high-security applications could be realisied.
>
> It seems with FUSE this is possible, but I have yet to find an encrypted
> filesystem that gives the above mentioned security. Truecrypt does not give
> that security as it itself needs and operates with root rights.
> I don't understand what the TC-programmers have done, because they seem not
> to have understood what FUSE is and can. They wrote their own cr*p around it
> instead of using the FUSE-interface, thereby totally _eliminating_ the good
> security mechanism FUSE offers by default.
>
> So, my wish is to mount an encrypted virtual HD to a mountpoint,
> and nobody else shall have access to it, especially not root or
> any program with root rights.
>
> Does anybody know of such an open-source solution for Linux?
>


Here's a sample FUSE source code (user-land) which demonstrates the above said 
security scheme:


/* hello.c

   FUSE: Filesystem in Userspace
   Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>

   This program can be distributed under the terms of the GNU GPL.
   See the file COPYING.


Note by U.Mutlu:
   this is a sample (hello.c) from the FUSE source distribution
   I modified it with my test code.

Compile:
   gcc -Wall -o hello hello.c `pkg-config fuse --cflags --libs`

Mounting as user:
   compile, s.a.
   $ mkdir mnt
   $ ./hello mnt
   $ ls -l mnt

root trying to access the mountpoint:
   in a second window try to access the mountpoint as root --> it will deny 
access to root, which is good:

   # ls -l
   ...
   d????????? ? ?      ?          ?            ? mnt
   ...

   # ls -l mnt
   ls: cannot access mnt: Permission denied

Unmounting:
   $ fusermount -u ./mnt

*/

#define FUSE_USE_VERSION 26

#include <fuse.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

static const char* hello_str = "Hello World!\n";
static const char* hello_path = "/hello.txt";

static const char* uenal_str = "hi there\n";
static const char* uenal_path = "/uenal.txt";


static int hello_getattr(const char *path, struct stat *stbuf)
{
         memset(stbuf, 0, sizeof(struct stat));
         if (strcmp(path, "/") == 0)
         {
                 stbuf->st_mode = S_IFDIR | 0755;
                 stbuf->st_nlink = 2;
                 return 0;
         }

         if (strcmp(path, hello_path) == 0)
         {
                 stbuf->st_mode = S_IFREG | 0444;
                 stbuf->st_nlink = 1;
                 stbuf->st_size = strlen(hello_str);
                 return 0;
         }

         if (strcmp(path, uenal_path) == 0)
         {
                 stbuf->st_mode = S_IFREG | 0444;
                 stbuf->st_nlink = 1;
                 stbuf->st_size = strlen(uenal_str);
                 return 0;
         }

         return -ENOENT;
}

static int hello_readdir(const char *path, void *buf, fuse_fill_dir_t filler, 
off_t offset, struct fuse_file_info *fi)
{
         (void) offset;
         (void) fi;

         if (strcmp(path, "/") != 0) return -ENOENT;

         filler(buf, ".", NULL, 0);
         filler(buf, "..", NULL, 0);

         filler(buf, hello_path + 1, NULL, 0);    // +1 um '/' zu skippen, 
s.o.; ...

         filler(buf, uenal_path + 1, NULL, 0);

         return 0;
}

static int hello_open(const char *path, struct fuse_file_info *fi)
{
      // if (strcmp(path, hello_path) != 0) return -ENOENT;

         if ((fi->flags & 3) != O_RDONLY) return -EACCES;

         return 0;
}

static int hello_read(const char *path, char *buf, size_t size, off_t offset, 
struct fuse_file_info *fi)
{
         (void) fi;

         if (strcmp(path, hello_path) == 0)
           {
             const size_t len = strlen(hello_str);
             if (offset < len)
               {
                 if ((offset + size) > len) size = len - offset;
                 memcpy(buf, hello_str + offset, size);
               }
             else
               size = 0;
             return size;
           }

         if (strcmp(path, uenal_path) == 0)
           {
             const size_t len = strlen(uenal_str);
             if (offset < len)
               {
                 if ((offset + size) > len) size = len - offset;
                 memcpy(buf, uenal_str + offset, size);
               }
             else
               size = 0;
             return size;
           }

         return -ENOENT;
}

static struct fuse_operations hello_oper =
{
         .getattr        = hello_getattr,
         .readdir        = hello_readdir,
         .open           = hello_open,
         .read           = hello_read,
};

int main(int argc, char *argv[])
{
         return fuse_main(argc, argv, &hello_oper, NULL);
}



