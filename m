From: tytso@mit.edu
Subject: Re: [PATCH] Please reserve INCOMPAT_DIRDATA flag
Date: Wed, 2 Jun 2010 10:34:27 -0400
Message-ID: <20100602143427.GE24062@thunk.org>
References: <20090906092546.GU4197@webber.adilger.int>
 <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
 <CE613B31-EA68-40A0-8F79-8A70A4CFD209@sun.com>
 <C19F99B4-0EBA-412B-8570-339B002DC028@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0FBOe3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jun 2010 10:34:29 -0400
Content-Disposition: inline
In-Reply-To: <C19F99B4-0EBA-412B-8570-339B002DC028@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 30, 2009 at 02:16:48PM -0700, Andreas Dilger wrote:
> Attached is a patch to reserve the data-in-dirent feature flag.

I had reserved this in ext4.h in the kernel, this is just a note to
say that I've checked in this change into e2fsprogs as well.

    	       	                    -	  Ted
