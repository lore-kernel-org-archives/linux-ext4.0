From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: inline_data,metadata_csum  a lot of bad csum for directories
Date: Mon, 1 Dec 2014 16:32:02 -0700
Message-ID: <32FC5424-8CFB-4D12-A201-1BFDD1552460@dilger.ca>
References: <877fybcvho.fsf@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40202 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbaLAXcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 18:32:04 -0500
Received: by mail-pa0-f42.google.com with SMTP id et14so12076356pad.15
        for <linux-ext4@vger.kernel.org>; Mon, 01 Dec 2014 15:32:04 -0800 (PST)
In-Reply-To: <877fybcvho.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 1, 2014, at 7:09 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
> Ted can you please clarify what is status of inline_data patchset.
> I've enabled inline_data testing in my test environment

I suspect that since inline_data and metadata_csum were developed
in isolation, they don't work well together yet.  I believe that
Darrick is working on fixing some issues in this area.

> I use xfstest-bld for this purpose, but most test generates a lot of incorrect
> inode's csum for directories(almost any test which makes/rm
> directories). What I'm doing wrong? Are where any important fix I'm missing? 
> Please post your test matrix
> 
> My config:
> e2fsprogs git commit: g210baa5
> ext4.git commit: recent tytso/dev ca83cc75a16f67
> ./kvm-xfstests -c inline generic/011  generic/013
> generic/013       [13:51:44]
> [  368.507266] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm rm: checksum invalid
> [  368.511098] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm rm: checksum invalid
> [  369.098863] EXT4-fs error (device vdd): ext4_iget:3918: inode #2108:comm rm: checksum invalid


Cheers, Andreas





