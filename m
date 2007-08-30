From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 1/4] Large Blocksize support for Ext2/3/4
Date: Wed, 29 Aug 2007 17:59:58 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708291758520.4670@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com>  <20070828190735.292638294@sgi.com>
  <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, adilger@clusterfs.com,
	sho@tnes.nec.co.jp, ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51223 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757804AbXH3A77 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Aug 2007 20:59:59 -0400
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 29 Aug 2007, Mingming Cao wrote:

> It's quite simple to support large block size in ext2/3/4, mostly just
> enlarge the block size limit.  But it is NOT possible to have 64kB
> blocksize on ext2/3/4 without some changes to the directory handling
> code.  The reason is that an empty 64kB directory block would have a
> rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
> the filesystem.  The proposed solution is to put 2 empty records in such
> a directory, or to special-case an impossible value like rec_len =
> 0xffff to handle this. 

Ahh. Good.

I could add the path to the large blocksize patchset?
