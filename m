From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC] [patch 3/3] i_version update for ext4: user interface
Date: Wed, 24 Jan 2007 13:14:14 -0500
Message-ID: <20070124181414.GC26806@fieldses.org>
References: <45B644C3.6000607@bull.net> <20070123185208.GH5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cordenner jean noel <jean-noel.cordenner@bull.net>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:56522 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXAXSOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jan 2007 13:14:17 -0500
Content-Disposition: inline
In-Reply-To: <20070123185208.GH5236@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 23, 2007 at 11:52:08AM -0700, Andreas Dilger wrote:
> On Jan 23, 2007  18:24 +0100, Cordenner jean noel wrote:
> > This patch adds a  ``st_i_version'' field in the stat
> > structure, and modifies the stat(2) syscall accordingly. Currently the
> > change is only visible on i386 and x86_64 archs.
> 
> What is the need for exporting i_version to userspace?

Maybe none, but it seems potentially really useful to me; in practice
aren't most uses of mtime/ctime exactly in order to find out if the file
has changed recently?

Who else is asking for finer time resolutions?  Is it because they need
the precision (or the inter-file comparison) or because they need to
know whether a file has changed?

Isn't anybody that currently maintains some cached information about a
filesystem currently living with the same races as NFS?

--b.
