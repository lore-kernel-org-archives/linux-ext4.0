From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: =?utf-8?Q?EXT4?= =?utf-8?B?77ya?= About the method of compute
 journal blocks
Date: Wed, 18 Jan 2017 10:41:58 -0500
Message-ID: <20170118154158.mme7qzuyqwkel6ok@thunk.org>
References: <CAHndWeV=wT74J2TBWsxcFF0Ks_u0UYQeD=040+m8CtP2L9d7XQ@mail.gmail.com>
 <20170117171024.lbunxryq5mjlvrvv@thunk.org>
 <CAHndWeUE6R=pCF0fh7wZL0ukuhDM0Liga32s7Jsp2Y_e798ohw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: yu xing <mdxy2014@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58352 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbdARQUS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Jan 2017 11:20:18 -0500
Content-Disposition: inline
In-Reply-To: <CAHndWeUE6R=pCF0fh7wZL0ukuhDM0Liga32s7Jsp2Y_e798ohw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 18, 2017 at 01:06:07PM +0800, yu xing wrote:
>       Do you mean, In future , the mke2fs will instead of the make_ext4fs ?
>       if true, maybe some functions from make_ext4fs will add to mke2fs.
>       such as pack the system.img from out/target/product/xxxxx/system,
>       and add selinux file_contexts into system , as the following command list
> 
>     make_ext4fs [ -l <len> ] [ -j <journal size> ] [ -b <block_size> ]
>     [ -g <blocks per group> ] [ -i <inodes> ] [ -I <inode size> ]
>     [ -L <label> ] [ -f ] [ -a <android mountpoint> ] [ -u ]
>     [ -S file_contexts ] [ -C fs_config ] [ -T timestamp ]
>     [ -z | -s ] [ -w ] [ -c ] [ -J ] [ -v ] [ -B <block_list_file> ]
>     <filename> [[<directory>] <target_out_directory>]
> 
>      the [<target_out_directory>] arguments is the packing directory
>      and the -S arguments is used to include the selinux file_contexts
> 
>      but in the mke2fs command, I can not find these functions( the
> newest version mk2fs whether or not support these functions,
>      if my wrong, please correct me), so maybe add these functions
> into mke2fs ?  the mke2fs command list as following:

Take a look at the AOSP master branch for e2fsprogs.  These changes
are not yet part of an official Android release (as they showed up
after the 'N' release) but you'll see that e2fsprogs has been updated
to 1.43 release and in the contrib/android directory, there is a new
e2fsdroid program.  That was some great work done by Adrien
Schildknecht as part of his Google intern project, and he consulted
with me on the design of how to refactor that functionality out of
make_ext4fs.

There are still some changes needed before we can completely get rid
of make_ext4fs (it is called programmatically from the volume manager,
and that last bit of work hasn't been converted yet).  And of course
there has still be some polishing and bug fixing that has been
happening to make sure things are smooth on Mac and Windows build
hosts, etc.  So as usual with the AOSP master branch, understand that
it is a work in progress, and it hasn't gotten the same level of
testing as an official android "letter" release.

Cheers,

						- Ted
