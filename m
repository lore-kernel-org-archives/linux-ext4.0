From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [ANNOUNCE] Online Hierarchical Storage Manager (OHSM v1.2)
Date: Tue, 23 Feb 2010 11:18:13 +0530
Message-ID: <ea11fea31002222148u4abe8235q4bb7ef855044b508@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: OHSM-DEV <ohsm-devel@lists.sourceforge.net>,
	kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f177.google.com ([209.85.223.177]:45298 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0BWFsf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 00:48:35 -0500
Received: by iwn7 with SMTP id 7so2838928iwn.4
        for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 21:48:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,
   We are pleased to announce the first official functional release of Online
Hierarchical Storage Manager (OHSM v1.2).  This is a RFC release and
not yet aimed at mainline inclusion.

OHSM is a tool to manage and move data across various class of storage.
It can help users to selectively place and move data across tiers such
as SSD, Raid 10, Raid 6 based on the attributes of the data. OHSM
supports background movement of data
without any visible change in a files namespace to users and user applications.
OHSM is built as an external module with recompilation required for
ext4. The current version of OHSM is based upon kernel 2.6.32.2

This release includes 3 core kernel patches:

1) An initial ext4 patch to adjust ext4's block allocation to use a
preferred block range per Ted
Tso's Dec 2008 write-up
(http://markmail.org/message/qp7zjhhdzxum7rfn).  This patch is not
ohsm specific.
2) A ohsm specific ext4 patch to provide callouts to the ohsm module.
3) The ohsm module itself

The source code for OHSM v1.2 is freely distributable under GPL.
The latest stable OHSM v1.2 is available at :
http://sourceforge.net/projects/ohsm/files/OHSMv1.2.tar.gz/download
Sources are available as git repository at :
git://ohsm.git.sourceforge.net/gitroot/ohsm/ohsm

The following list describes the features of OHSM
* Support for Ext4.
* File System callouts
* Policy based File Migration
* Per inode information maintainer in user xattr area
* XML based policy files
* Support for RAID
* DTD based XML validation
- Automatic Relocation engine
* Selective Relocation of mountpoint/Subdirectories
* Selection Relocation based on specific rule
* File Placement based on:
 + UID
 + GID
 +  File Type
 + Directory Name
* File Migration based on
 + UID
 + GID
 + FILE SIZE
 + ACCESS AGE
 + MODIFICATION AGE
 - File Access Temperatue
 - File I/O Temperature
+
(*=current features, -= on our todo list, +=support already present)

Here are some simple examples :-
$ ohsm enable sample/ohsm.xml
OHSM enabled successfully on '/tmp/mnt'

$ ohsm relocate -m /tmp/mnt
Relocation performed successfully.

$ ohsm status /tmp/mnt
OHSM is enabled on '/tmp/mnt'

$ ohsm disable /tmp/mnt
OHSM disabled successfully on '/tmp/mnt'

$ ohsm
Usage: ohsm subcommand [optstring ..] [parameters ..]
     Subcommands :
              enable  - Enable OHSM
              disable - Disable OHSM
              status  - Show status of OHSM
              relocate -Trigger relocation on filesystem
              update  - Update OHSM instance parameters
              help     -Show usage

*Note* that the code for OHSM is still in early stages
Feedback, bug reports and patches, as always, are welcomed.
(ohsm-devel@lists.sourceforge.net)


-- 
Thanks -
OHSM team
