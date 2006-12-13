From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 14:33:38 -0700
Message-ID: <20061213213338.GZ5937@schatzie.adilger.int>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net> <m3wt4vzxje.fsf@bzzz.home.net> <458010CE.6020402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57840 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbWLMWDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 17:03:40 -0500
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <458010CE.6020402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 13, 2006  08:40 -0600, Eric Sandeen wrote:
> This is probably a discrepancy that comes from reading the block device 
> directly, right?  Which is not necessarily in sync with the address 
> space for the filesystem.

In fact, the block device IS in sync with the filesystem address space,
but only for metadata.  The file data each has its own address space and
is not coherent.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
