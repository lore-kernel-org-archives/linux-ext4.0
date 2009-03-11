From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 00:50:51 -0400
Message-ID: <20090311045051.GA13698@mit.edu>
References: <1236655451.30280.29.camel@kulgan.wumi.org.au> <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au> <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu> <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int> <1236735808.16191.23.camel@kulgan.wumi.org.au> <1236736137.16191.25.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58540 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZCKEvP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Mar 2009 00:51:15 -0400
Content-Disposition: inline
In-Reply-To: <1236736137.16191.25.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you tell us something about the hardware that is behind this
filesystem?  What sort of disks, raid controller if any, etc. are you
using?

						- Ted
