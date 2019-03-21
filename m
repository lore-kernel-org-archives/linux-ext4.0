Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802ABC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FF24218E2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfCUOby (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:31:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45717 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbfCUOby (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 10:31:54 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LEVf3l018271
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 10:31:42 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 94140420AA8; Thu, 21 Mar 2019 10:31:41 -0400 (EDT)
Date:   Thu, 21 Mar 2019 10:31:41 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321143141.GB9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321102742.k2oos4epoj6fyjao@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 11:27:42AM +0100, Lukas Czerner wrote:
> 
> lv_role=public does not exclude snapshots and so it will fail later in
> e2scrub when you try to create a snapshot of a thicksnapshot which is
> not supported.

Ah, good point.  Thanks for pointing that out.

> Also I am not sure what's the rush, but it seems you've ignored my other
> suggestions.

I did consider them all, but there were reasons why I didn't use them.
One of them wasn't practical because I needed LVM2_VG_NAME; when you
made that suggestion, I hadn't published the patch needed to fix
Debian Bug #924301.  Of course, if we use your suggestion of using "-S
vg_free > ${snap_size}" it will obviate that need; so thanks for that
suggestion.

The reason why I didn't take one of your other suggestions is that we
need to check whether or not the file system is mounted, and so we
needed the mountpoint in lsblk, and once you ask for the mountpoint,
we can no longer use awk to select a field, since an unmounted file
system shows up as a an empty column.

% sudo lsblk -o MOUNTPOINT,FSTYPE,NAME -l
           LVM2_member nvme0n1p3_crypt
           ext4        lambda-uroot
[SWAP]     swap        lambda-swap_1
/          ext4        lambda-root
           ext4        lambda-old--files
           ext4        lambda-library
           ext4        lambda-test--4k
           ext4        lambda-scratch
           ext4        lambda-test--1k
                       lambda-scratch2
                       lambda-scratch3
           ext4        lambda-results
                       lambda-thinpool_tmeta
                       lambda-thinpool_tdata

I also really didn't like using grep to select the file system type
ext[234], since if it would falsely select a LV name that contained
"ext4", e.g.:

/home/dave       xfs        rhel-ext4--sucks

:-)

We could have used awk to select the field, but that still doesn't
deal with the mountpoint column being empty when it is unmounted.  I
did briefly consider using lsblk -J, but I didn't want to add a
dependency on the jq[1] package (and I didn't even know if RHEL/Fedora
packages jq).

[1] https://packages.debian.org/stretch/jq

Cheers,

					- Ted
