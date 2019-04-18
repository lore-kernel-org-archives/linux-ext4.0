Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD03C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 827E9217F9
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="p7MXDVRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfDRSzS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:55:18 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:32952 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfDRSzR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 14:55:17 -0400
Received: by mail-pf1-f177.google.com with SMTP id h5so1523123pfo.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 11:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Pt0iOy7sh44HMAoeOj/HRfN/XwQo9+nN02VJxi5kIgM=;
        b=p7MXDVRNlDpRyW+AQH9W24Zv5UBiEZtU/Be+hpDNyeiw4O0cpjFaraDrLS+pNfdmTd
         RJkKoxOBFPALeq3TbuO1fI4YOTcKm/hcRGKDPE4VmWvNQGwCjZzyyoN5ic1ky7HRPh+y
         17SoP9yRlfkaBfx3cEgyA4W4Gui8FxpfznY8z+u/LNYcOorCPu3BrdML2S3lIWQ2P27J
         9ImWveGraBNiEUCI342IfdaX7rapTTwoowvKVEcZuHT8YwjNNDtKPzhGy+S30JZZsKII
         koKeuVE3SYXWvd4dMXntGQSnhoJvmRnYv7dJTwcEXORFtGLa+XZI2dGSYzr9lwpymXZJ
         pU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Pt0iOy7sh44HMAoeOj/HRfN/XwQo9+nN02VJxi5kIgM=;
        b=G0tzZxx12ofN4n5KEKVyq0xVrJ+e79AdRa2gmhBP2+FOJXVzfX5OyNbEGky3FhrgAo
         y8aa+GGNlC4WY8dwPgYqtWBfcSF1Wfu+w9nqj+BipU4lFDLBv9HCC6zvr6KwD9QxV5WZ
         gZ7sauIWZAivfNZG5urApAXjo4n5OH/lZ799k5Y1svNfBOS2+Q6Yz3vIV66Ss8G0H1Yr
         jevqKSZO67vPS2R/jM2Vzu7c5sHco3oN+ST5rP8EBYCeqr9U8JQsaEUr4ZOw+9UbjCf0
         LbBMcRxsJAkgCW9W/T7z3P5aJ870yebJfhZ2suVYVXOKpbFUI/kM1YxCqYU+qj+49qrA
         XxXA==
X-Gm-Message-State: APjAAAVzMXUmEcOREXJ57XFerG7rAn5EsN5JRj4AAcabXCChplj9DNro
        jhjPceCm8C08jARV+DKSimstwhPqfho=
X-Google-Smtp-Source: APXvYqyuC+v8t+kHys5mFlsFewyAW/kSdJIs4/tFDFINfWgZoT3Ew2/HxU7BH5vfxpQ5fksCN5wG7g==
X-Received: by 2002:a62:1385:: with SMTP id 5mr98121052pft.221.1555613716783;
        Thu, 18 Apr 2019 11:55:16 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id 20sm3648967pfn.131.2019.04.18.11.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 11:55:16 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <37F8F5E5-086B-4CC9-8673-89515AE5AA91@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D76254C7-060E-4DF2-B667-115D7901C434";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. [Solved]
Date:   Thu, 18 Apr 2019 12:55:12 -0600
In-Reply-To: <CABxFBzF0Sa3iJH=aTn-2d5sAZnrUC8ek1+N9d_uw9O8M1bJ6tg@mail.gmail.com>
Cc:     linux-ext4@vger.kernel.org
To:     Andrea Lo Pumo <alopumo@movia.biz>
References: <CABxFBzF0Sa3iJH=aTn-2d5sAZnrUC8ek1+N9d_uw9O8M1bJ6tg@mail.gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_D76254C7-060E-4DF2-B667-115D7901C434
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 18, 2019, at 4:54 AM, Andrea Lo Pumo <alopumo@movia.biz> wrote:
>=20
> I have been able to recover the files. It seems that they unmounted
> the filesystem shortly after having mounted it. So ext4lazyinit did
> not overwrite all the inode tables.
>=20
> Here I write a more detailed report, in the hope it will be useful for
> others. If you would like to review it, it will be appreciated and I
> will write a tutorial somewhere.
>=20
> Also, could the modified do_dump() command  be usefully integrated in =
debugfs?

Andrea,
it sounds interesting what you have done, and I would encourage you to
finish off the work you have started so it is available for others:
- make the inode/directory dumping flexible (e.g. optionally allow
  dumping a range of inodes so it doesn't interfere with normal use)
- allow the checksum verification to be turned on/off
- add some documentation to the usage and man page so that users
  will know that this option is available

Cheers, Andreas

>=20
> ---- Report ---
>=20
> On /dev/sda1 there was an ext4 file system with a lot of large files.
> Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The result is
> that now /dev/sda1 is "empty": mounting it shows no files.
> Luckily, /dev/sda1 was immediately umounted and the majority of files
> were recovered.
>=20
> I have modified the debugfs / libext2fs code to ignore the checksums
> of the files and the directories (see Note 1), and run debugfs -c
> (catastrophic mode).
> Then, with the ls -l and rdump commands of debugfs, the recovery was =
done.
>=20
> Since we were not interested in recovering all files, but only certain
> directories, I proceeded as follow:
>=20
>   - modified do_dump() of debugfs/dump.c, to dump all directories
> ("directory" intended as the special file that contains the list of
> sub-files and sub-directories). This is accomplished by doing this:
>=20
>        for (inode =3D 1; inode < (ext2_ino_t)0xffffffff; inode++) {
>           ....
>           sprintf(outFilename, "%u", inode);
>           out_fn =3D outFilename;
>=20
>           if (inode % 1000000 =3D=3D 0) {
>              printf("%u\n", inode); // print the current inode as a
> progress report. There are a total of 2**32-1 inodes.
>           }
>=20
>           unsigned int blocks =3D inode_blocks(inode);
>           if (blocks =3D=3D 0)
>              continue;
>=20
>           ....
>=20
>           dump_file(argv[0], inode, fd, preserve, out_fn);
>=20
>           ....
>=20
>         }
>=20
>   inode_blocks() is a custom function, which is attached at the end
> of this email, and is used to consider only inodes with a block
> count > 0, a link count > 0, a deletion time =3D 0 and of type =
directory.
>=20
> Compiling the modified debugfs, and issuing the dump <1> 111 command
> (arguments are irrelevant), one gets all the directory-files of the
> filesystem:
>  mkdir recover
>  cd recover
>  sudo path/to/debugfs/debugfs -c /dev/loop12
>  debugfs>   dump <1> 111
>=20
> Then, do "grep NAME recover/ -r", where NAME is the name of a
> sub-directory or a sub-file of the directory you are looking for.
> If the inode you are looking for was not destroyed, grep will print
> something like:
>   Binary file recover/7452143 matched.
> If you get more than one match. Use the command "strings", e.g.
> strings recover/7452143, an you will get a (somewhat garbled) list of
> files and directories inside the directory recover/7452143. So you can
> choose the appropriate match.
>=20
> Now, assuming that you settled on a match, that number, e.g. 7452143,
> is the inode number of the directory.
>=20
> Open debugfs -c, and do
>=20
>  debugfs > ls -l <7452143>
>=20
>    ... list of files of <7452143> ...
>=20
>  debugfs > rdump <7452143> .
>=20
> rdump will recursively dump the content of the directory.
>=20
> Note 1: I am seeing that debugfs has a -n option to disable checksum
> verification. Perhaps, it is the same to what I have done? In details,
> I have disabled the following errors: EXT2_ET_DIR_CSUM_INVALID,
> EXT2_ET_EXTENT_CSUM_INVALID, disabled "Verify the inode checksum."  in
> ext2fs_read_inode_full().
>=20
> Final note, debugfs is a powerful tool, by hacking its code you can do
> a lot. For example, using inode->i_mtime and modifying do_rdump(), you
> can dump only files with a modification time greater than some date.
>=20
> ------
>=20
> unsigned int inode_blocks(ext2_ino_t  inode)
> {
>    struct ext2_inode *inode_buf =3D (struct ext2_inode *)
> malloc(EXT2_INODE_SIZE(current_fs->super));
>=20
>    if (!inode_buf) {
>        fprintf(stderr, "%u do_stat: can't allocate buffer\n", inode);
>        return 0;
>    }
>=20
>    if (debugfs_read_inode_full(inode, inode_buf, "inode_blocks",
>                    EXT2_INODE_SIZE(current_fs->super))) {
>        free(inode_buf);
>        return 0;
>    }
>=20
>    char ok =3D inode_buf->i_blocks !=3D 0 && inode_buf->i_links_count =
!=3D 0 &&
>            inode_buf->i_dtime =3D=3D 0 &&
>            LINUX_S_ISDIR(inode_buf->i_mode);
>=20
>    unsigned int ret  =3D ok ? inode_buf->i_blocks : 0;
>=20
>    free(inode_buf);
>=20
>    return ret;
> }
>=20
> --------
>=20
> Il giorno gio 11 apr 2019 alle ore 23:23 Theodore Ts'o <tytso@mit.edu>
> ha scritto:
>>=20
>> On Thu, Apr 11, 2019 at 11:37:55AM +0200, Andrea Lo Pumo wrote:
>>> - The inode map has been overwritten too.
>>> - However, the data is still there in the disk, and also the related
>>> inode structures. (Just the inode map is missing right?). So, if one
>>> is able to locate these inode structures, the relative files could =
be
>>> recovered. We know the name of important directories and files to be
>>> recovered. Could this help?
>>=20
>> Unfortunately, what gets overwritten is the inode table, which
>> contains the inode structures.  So all of the information which says,
>> "logical block N of inode M is located on physical block P" is gone.
>>=20
>> So your only hope is going to be to use a program which looks at
>> individual data blocks, and assumes that (for the most part) files
>> tend to be allocated contiguously on the storage device.  =
Fortunately,
>> such a tool has already been written, and it is an open source tool
>> called PhotoRec[1].  I see however, you've already tried PhotoRec.
>>=20
>>> I could also invest some programming efforts to solve this issue, by
>>> hacking some available tools, if this could help and is not too
>>> complex. In this regard, I have this question: given that I know the
>>> name of some important directories and files to be recovered,
>>> theoretically I could write a program that "greps" the name of the
>>> file in /dev/sda1 and, around that point, I should locate the inode
>>> structure, and with the inode recover the whole file? Any hint =
toward
>>> this direction? I don't have experience with ext programming, but I =
am
>>> willing to hack.
>>=20
>> Yeah, unfortunately, no.  You'll be able to find the directory data
>> block, sure.  And that will contain the inode number.  But mke2fs
>> overwrites the entire inode table, so there's nothing that you can
>> find.
>>=20
>>> Final question: are there tools to handle this situation? testdisk =
and
>>> ext4magic do not seem to give good results. Photorec is useless to
>>> recover large .tar.gz and .ogg files, and more importantly the name =
of
>>> the file, which we also need.
>>=20
>> You've listed the primary tools that are available already.  It is
>> possible to configure mke2fs to create an undo file, and then when
>> something screws up they can use the e2undo file to unwind the
>> modifications made by mke2fs (or e2fsck, if the undo file generation
>> is enabled by e2fsck).
>>=20
>> This feature is not enabled by default, mainly because (a) it slows
>> down the mke2fs and e2fsck operations, and that tends to make system
>> administrators cranky, and (b) you have to put the e2undo file
>> somewhere, and you need to have some kind of scheme to delete old
>> e2undo files.  So there is a lot of distribution integration changes
>> that has never been done.
>>=20
>> Telling you this now isn't particularly helpful, since it's basically
>> suggesting that you close the barn door after the horse has escaped.
>> However, along with other changes you might want to make to your
>> procedures (such as doing regular backups) to avoid future mistakes =
of
>> this ilk, it might be something to consider.
>>=20
>> Good luck, and sorry there's not much else help we can offer you,
>>=20
>>                                        - Ted


Cheers, Andreas






--Apple-Mail=_D76254C7-060E-4DF2-B667-115D7901C434
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAly4yBEACgkQcqXauRfM
H+DorxAAm8hj2Ue3WfhSvJYrgNW00MvN7hsF8q6hq0hGAQ8ifVZfycP78DZn//zO
Jx3OC9ppKLMRAidEnmiaiWR65D7TKccjU7YK8MUtkxWR0G6QzEMf+bnYEb9pkQ4B
ZKF08glKo4Fkm0uCWJn9x5whndUh8/s4AkaTixo9DK5zpMqtMcSJfDkBRfoDpQkS
CrjORCKN1vLYL1H1n0N4uwGWHkMRbGKpyJ6tr98IxPkckJOxbv67i7zcIxang/C9
UZtXrsNWnaeSRRKbw2Bb3VeYKNO53hCsWdcB7jzKgc10A1rQd0fI8LVctnj9Jv4t
lsBh+ZybCvR1ZhaFNXiA8N82DeEUDaBAnW8ZnwmVsKUbS5NrxpSW54FYlnW4T7h8
fe2LhqW64NWfOUUlmHdvpNgCGN9FdPD/oVFRRyihPw3vGpGD7OeDonzRbdi1TP/H
00KYf6YPptH/YY27/UCYPw6yqtNKGRxk+UnheBALC3YdkzZkv9Dcr7INzAT/ITHW
KCeJMYbGhHo7lIDOXcu0lXD26v7VKHz41bNDIyh2vl6FLSu2MbTkQPQByfgissD2
nCIPv7Ats7amtWFrabZfF+avwB65wl2b+L6dzb2aExA52ffNrzxJYuTQifimT01Z
aJZXS8BoL30MzmOrlwyzyp7bSw/t7fSkmiDW2KSHYVW3YJw7s6k=
=ptI2
-----END PGP SIGNATURE-----

--Apple-Mail=_D76254C7-060E-4DF2-B667-115D7901C434--
