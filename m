Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722ADC10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 10:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C01E2054F
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 10:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=movia-biz.20150623.gappssmtp.com header.i=@movia-biz.20150623.gappssmtp.com header.b="T0k63FAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfDRKyN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 06:54:13 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:33281 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388323AbfDRKyN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 06:54:13 -0400
Received: by mail-it1-f169.google.com with SMTP id v8so7733858itf.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 03:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=movia-biz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:cc;
        bh=j25rwr656RKmlTPZFxCRi1DB43UzQf/zfFBDnDyU0jM=;
        b=T0k63FAqDC9jGDX4uDgrRWp3E3Abh107UsoZMwJ1fthxDVhThqmp+nW/YI3gqGsJtI
         fj7jQ0HM3HhDtjMIKJ8TfOkdiKG6wPy2OQ412x5sNJMAjOFQtnJ5e8ap5qeuuA1aKaT2
         tUCCTZJ/2Wp1JHyPX/q809KVYDiqWqyN6/6+2EluOGE2MmvuAI0FUwYjsP1Dsq7Gk1Lm
         aPQvsIXoxe+GOXndtE4FivuTeSEfMFN5aHq4oAt/RixTCgV8PhX0LcjA97AUl8cVAGYv
         ddLa86GLpGEe0wxEW8X74/rgEeQovUftkII6HWsY2UY7r81Nm1Qe49d7uHqNfdb8cidV
         LHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:cc;
        bh=j25rwr656RKmlTPZFxCRi1DB43UzQf/zfFBDnDyU0jM=;
        b=nQaPkOFHO3UqPmdpWWhfm0d9Pixk8atIXojrvZtpi5Nc7oy1sVdQhnyMou9r6mV6cM
         gL2wsTgzeMRPipMBt2ro1I0HMA8zC56v0zLvYQBoqmeDA+i+inj+lLteU1lZ5UsN+dvw
         8Eg0pSYM+fDLANAZUcv9q45G5Q/MMrkYSG+Lj5ASWWfryBaTdbCT+eIR7sA1XvcOQGMI
         PEYz3fbsntlpbMcVIUu0P5tgouCtYuGDE6WNiqNrZqNihOKkEmQKjvaVfFBx7uAYSvho
         N2UeSNbS0GM2dfB+zbCFzmpXfBfdDXv99jbc+hQwQUDDKtTtz+pbJWE88kcV5mqbUASo
         IaYQ==
X-Gm-Message-State: APjAAAX+67MuZc7LFobMv7y3Sct6TY1rMYQ05413cDPeDtywok+8BFFe
        fTCxqYhWyPcDTahzm6mJswRPkVfxuSanAu8WF0zW4evLV8s=
X-Google-Smtp-Source: APXvYqzdHTGJsZjHItVSBDgHRnEQ2puecRiuWzS7gwp6Jyt+xZphoMd7i3rzYNd6y0S+5J8MqNXYPfTzPLqjsTXH8ZY=
X-Received: by 2002:a24:7350:: with SMTP id y77mr2366678itb.52.1555584852098;
 Thu, 18 Apr 2019 03:54:12 -0700 (PDT)
MIME-Version: 1.0
From:   Andrea Lo Pumo <alopumo@movia.biz>
Date:   Thu, 18 Apr 2019 12:54:01 +0200
Message-ID: <CABxFBzF0Sa3iJH=aTn-2d5sAZnrUC8ek1+N9d_uw9O8M1bJ6tg@mail.gmail.com>
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. [Solved]
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I have been able to recover the files. It seems that they unmounted
the filesystem shortly after having mounted it. So ext4lazyinit did
not overwrite all the inode tables.

Here I write a more detailed report, in the hope it will be useful for
others. If you would like to review it, it will be appreciated and I
will write a tutorial somewhere.

Also, could the modified do_dump() command  be usefully integrated in debugfs?

---- Report ---

On /dev/sda1 there was an ext4 file system with a lot of large files.
Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The result is
that now /dev/sda1 is "empty": mounting it shows no files.
Luckily, /dev/sda1 was immediately umounted and the majority of files
were recovered.

I have modified the debugfs / libext2fs code to ignore the checksums
of the files and the directories (see Note 1), and run debugfs -c
(catastrophic mode).
Then, with the ls -l and rdump commands of debugfs, the recovery was done.

Since we were not interested in recovering all files, but only certain
directories, I proceeded as follow:

   - modified do_dump() of debugfs/dump.c, to dump all directories
("directory" intended as the special file that contains the list of
sub-files and sub-directories). This is accomplished by doing this:

        for (inode = 1; inode < (ext2_ino_t)0xffffffff; inode++) {
           ....
           sprintf(outFilename, "%u", inode);
           out_fn = outFilename;

           if (inode % 1000000 == 0) {
              printf("%u\n", inode); // print the current inode as a
progress report. There are a total of 2**32-1 inodes.
           }

           unsigned int blocks = inode_blocks(inode);
           if (blocks == 0)
              continue;

           ....

           dump_file(argv[0], inode, fd, preserve, out_fn);

           ....

         }

   inode_blocks() is a custom function, which is attached at the end
of this email, and is used to consider only inodes with a block count
> 0, a link count > 0, a deletion time = 0 and of type directory.

Compiling the modified debugfs, and issuing the dump <1> 111 command
(arguments are irrelevant), one gets all the directory-files of the
filesystem:
  mkdir recover
  cd recover
  sudo path/to/debugfs/debugfs -c /dev/loop12
  debugfs>   dump <1> 111

Then, do "grep NAME recover/ -r", where NAME is the name of a
sub-directory or a sub-file of the directory you are looking for.
If the inode you are looking for was not destroyed, grep will print
something like:
   Binary file recover/7452143 matched.
If you get more than one match. Use the command "strings", e.g.
strings recover/7452143, an you will get a (somewhat garbled) list of
files and directories inside the directory recover/7452143. So you can
choose the appropriate match.

Now, assuming that you settled on a match, that number, e.g. 7452143,
is the inode number of the directory.

Open debugfs -c, and do

  debugfs > ls -l <7452143>

    ... list of files of <7452143> ...

  debugfs > rdump <7452143> .

rdump will recursively dump the content of the directory.

Note 1: I am seeing that debugfs has a -n option to disable checksum
verification. Perhaps, it is the same to what I have done? In details,
I have disabled the following errors: EXT2_ET_DIR_CSUM_INVALID,
EXT2_ET_EXTENT_CSUM_INVALID, disabled "Verify the inode checksum."  in
 ext2fs_read_inode_full().

Final note, debugfs is a powerful tool, by hacking its code you can do
a lot. For example, using inode->i_mtime and modifying do_rdump(), you
can dump only files with a modification time greater than some date.

------

unsigned int inode_blocks(ext2_ino_t  inode)
{
    struct ext2_inode *inode_buf = (struct ext2_inode *)
malloc(EXT2_INODE_SIZE(current_fs->super));

    if (!inode_buf) {
        fprintf(stderr, "%u do_stat: can't allocate buffer\n", inode);
        return 0;
    }

    if (debugfs_read_inode_full(inode, inode_buf, "inode_blocks",
                    EXT2_INODE_SIZE(current_fs->super))) {
        free(inode_buf);
        return 0;
    }

    char ok = inode_buf->i_blocks != 0 && inode_buf->i_links_count != 0 &&
            inode_buf->i_dtime == 0 &&
            LINUX_S_ISDIR(inode_buf->i_mode);

    unsigned int ret  = ok ? inode_buf->i_blocks : 0;

    free(inode_buf);

    return ret;
}

--------

Il giorno gio 11 apr 2019 alle ore 23:23 Theodore Ts'o <tytso@mit.edu>
ha scritto:
>
> On Thu, Apr 11, 2019 at 11:37:55AM +0200, Andrea Lo Pumo wrote:
> > - The inode map has been overwritten too.
> > - However, the data is still there in the disk, and also the related
> > inode structures. (Just the inode map is missing right?). So, if one
> > is able to locate these inode structures, the relative files could be
> > recovered. We know the name of important directories and files to be
> > recovered. Could this help?
>
> Unfortunately, what gets overwritten is the inode table, which
> contains the inode structures.  So all of the information which says,
> "logical block N of inode M is located on physical block P" is gone.
>
> So your only hope is going to be to use a program which looks at
> individual data blocks, and assumes that (for the most part) files
> tend to be allocated contiguously on the storage device.  Fortunately,
> such a tool has already been written, and it is an open source tool
> called PhotoRec[1].  I see however, you've already tried PhotoRec.
>
> > I could also invest some programming efforts to solve this issue, by
> > hacking some available tools, if this could help and is not too
> > complex. In this regard, I have this question: given that I know the
> > name of some important directories and files to be recovered,
> > theoretically I could write a program that "greps" the name of the
> > file in /dev/sda1 and, around that point, I should locate the inode
> > structure, and with the inode recover the whole file? Any hint toward
> > this direction? I don't have experience with ext programming, but I am
> > willing to hack.
>
> Yeah, unfortunately, no.  You'll be able to find the directory data
> block, sure.  And that will contain the inode number.  But mke2fs
> overwrites the entire inode table, so there's nothing that you can
> find.
>
> > Final question: are there tools to handle this situation? testdisk and
> > ext4magic do not seem to give good results. Photorec is useless to
> > recover large .tar.gz and .ogg files, and more importantly the name of
> > the file, which we also need.
>
> You've listed the primary tools that are available already.  It is
> possible to configure mke2fs to create an undo file, and then when
> something screws up they can use the e2undo file to unwind the
> modifications made by mke2fs (or e2fsck, if the undo file generation
> is enabled by e2fsck).
>
> This feature is not enabled by default, mainly because (a) it slows
> down the mke2fs and e2fsck operations, and that tends to make system
> administrators cranky, and (b) you have to put the e2undo file
> somewhere, and you need to have some kind of scheme to delete old
> e2undo files.  So there is a lot of distribution integration changes
> that has never been done.
>
> Telling you this now isn't particularly helpful, since it's basically
> suggesting that you close the barn door after the horse has escaped.
> However, along with other changes you might want to make to your
> procedures (such as doing regular backups) to avoid future mistakes of
> this ilk, it might be something to consider.
>
> Good luck, and sorry there's not much else help we can offer you,
>
>                                         - Ted
