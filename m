From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 07:46:47 -0400
Message-ID: <20080909114647.GA14052@infradead.org>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.ed, adilger@sun.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYIILqt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 07:46:49 -0400
Content-Disposition: inline
In-Reply-To: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 02:42:22PM +0530, Aneesh Kumar K.V wrote:
> This patch adds new option, -E to chattr. The -E option
> is used to convert the ext3 format (non extent) file
> to ext4 (extent) format. This can be used to migrate
> the ext3 file system to ext4 file system.

I think this is an awkware interfac.  Chattr is supposed to set simple
binary flags and not a front end to complicated filesystem conversions.

