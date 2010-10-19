From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Committing changes to an ext3_inode structure
Date: Tue, 19 Oct 2010 16:46:06 -0600
Message-ID: <1CEB57FF-115D-4B11-86A5-1E373090DC13@dilger.ca>
References: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Felipe Franciosi <felipe@paradoxo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:26702 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0JSWqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 18:46:08 -0400
In-Reply-To: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-19, at 09:23, Felipe Franciosi wrote:
> I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and evaluate different methods for migrating datablocks for a given inode on the fly.
> 
> I have created an ioctl call that implements some verifications and invokes a function I wrote in balloc.c for such migration.

Are you aware that there already is the ability to do on-the-fly migration of files in ext4?  This was developed quite some time ago and is in ext4 in newer kernels (not sure of the exact version, maybe 2.6.32 or so).

I would strongly recommend that you investigate that code, since it could definitely use some good testing/inspection/enhancement (as needed).  It is in fs/ext4/migrate.c, though I'm not sure where the user-space tools are located (maybe e2fsprogs?).

Cheers, Andreas





