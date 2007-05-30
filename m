From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 0/2] i_version update
Date: Wed, 30 May 2007 10:21:00 +1000
Message-ID: <20070530002100.GV85884050@sgi.com>
References: <46570DFB.3080101@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52343 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751226AbXE3AVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 20:21:13 -0400
Content-Disposition: inline
In-Reply-To: <46570DFB.3080101@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 25, 2007 at 06:25:31PM +0200, Jean noel Cordenner wrote:
> Hi,
> 
> This is an update of the i_version patch.
> The i_version field is a 64bit counter that is set on every inode
> creation and that is incremented every time the inode data is modified
> (similarly to the "ctime" time-stamp).

My understanding (please correct me if I'm wrong) is that the
requirements are much more rigourous than simply incrementing an in
memory counter on every change.  i.e. the this counter has to
survive server crashes intact so clients never see the counter go
backwards. That means version number changes need to be journalled
along with the operation that caused the change of the version
number.

> The aim is to fulfill a NFSv4 requirement for rfc3530:
> "5.5.  Mandatory Attributes - Definitions
> Name		#	DataType   Access   Description
> ___________________________________________________________________
> change		3	uint64       READ     A value created by the
> 		server that the client can use to determine if file
> 		data, directory contents or attributes of the object
                ^^^^

File data writes are included in this list of things that need to
increment the version field. Hence to fulfill the crash requirement,
that implies server data writes either need to be synchronous or
journalled...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
