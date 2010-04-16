From: tytso@mit.edu
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 10:29:31 -0400
Message-ID: <20100416142931.GB32634@thunk.org>
References: <20100416123526.GW21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-driver@qlogic.com,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56285 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab0DPQrX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 12:47:23 -0400
Content-Disposition: inline
In-Reply-To: <20100416123526.GW21495@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 16, 2010 at 02:35:26PM +0200, Andre Noll wrote:
> Hi
> 
> I'm seeing the following errors when writing to an ext4 file system:
> 
> 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
> 	end_request: I/O error, dev sda, sector 7812771880

These look like hardware errors; it may not be the qla2xxx driver's
fault, but actually the fault of the hard disk....

       	   	    	      	     	  - Ted
