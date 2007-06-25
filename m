From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 1/11][take 2] add new mkfs option to create ext4 filesystems
Date: Mon, 25 Jun 2007 15:59:23 -0600
Message-ID: <20070625215922.GM5181@schatzie.adilger.int>
References: <467A936F.7030502@bull.net> <467FD71A.7030003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43639 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXFYV70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2007 17:59:26 -0400
Content-Disposition: inline
In-Reply-To: <467FD71A.7030003@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 25, 2007  20:24 +0530, Aneesh Kumar K.V wrote:
> Why would one need variable descriptor size. Right now we have only two 
> descriptor sizes right (32 and 64 ).  Can't we figure out
> the descriptor size we should use by looking at the partition size ? What 
> is that i am missing ?. 

Because one may want to expand an ext4 filesystem over 16TB after format
time, and this would require a 64-byte descriptor.  In ext4 the descriptor
is almost completely full already (to deal with BIG_BG changes, and possibly
large blocksize changes), so we may even need 128-byte descriptors soon.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
