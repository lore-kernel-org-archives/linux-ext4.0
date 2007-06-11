From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 0/12] e2fsprogs: add 64-bit support
Date: Mon, 11 Jun 2007 17:12:48 -0600
Message-ID: <20070611231248.GE5181@schatzie.adilger.int>
References: <466D7B54.7050005@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38480 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXFKXMv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 19:12:51 -0400
Content-Disposition: inline
In-Reply-To: <466D7B54.7050005@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:41 +0200, Valerie Clement wrote:
> This patchset is also not complete:
> TODO:
>   - update code under ext2ed/,

This code should just be removed entirely.  It is dangerous to use, and
by including it in e2fsprogs it lends a false sense of credibility to
the code.  Hopefully most of the functionality here has been incorporated
into debugfs?

> Code compiled, booted and briefly tested on a 20TB device (mkfs, 
> debugfs, e2fsck, dumpe2fs, filefrag tested)
> Some non-regression tests also done on ext3 filesystems when compiling 
> code without _EXT4FS_ option.

Did you run the "make check" tests?  We've found these invaluable for
catching regressions.  Ideally there would also be some test cases
for this support using "lazy_bg", a script to generate the filesystem,
and conditional upon being able to create sparse files that big.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
