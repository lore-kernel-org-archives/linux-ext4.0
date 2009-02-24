From: Theodore Tso <tytso@mit.edu>
Subject: Re: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 14:07:10 -0500
Message-ID: <20090224190709.GG5482@mit.edu>
References: <alpine.DEB.2.00.0902241713520.16614@pintail.doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34611 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZBXTHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 14:07:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902241713520.16614@pintail.doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 05:13:52PM +0000, Felipe Franciosi wrote:
> Hi there!
> 
> I've been trying to write a kernel module that is capable of locating a specific mounted filesystem (ext2/3) and dump all the inode entries that are in use. I have two questions:

Why are you doing this in a kernel module?  What is this for?

    	    	       	    	   	    	 - Ted
