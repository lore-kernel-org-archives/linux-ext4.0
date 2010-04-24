From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Sat, 24 Apr 2010 13:11:57 -0400
Message-ID: <1272129117.2093.5.camel@faldara>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu>
	 <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu>
	 <20090511120936.GB6277@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:62157 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0DXRMA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 13:12:00 -0400
In-Reply-To: <20090511120936.GB6277@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-05-11 at 08:09 -0400, Theodore Tso wrote:
> I just did a bit more web browsing, and it appears that OCZ's
> userspace support for trim is currently Windows-only, and they've
> implemented it by taking the filesystme off line, and running a
> userspace utility that sends TRIM requests for all of the free space
> on the drive.

Recent releases of hdparm also support sending down TRIM commands and
have a script that maps the unused blocks of the fs to trim them.
Someone even posted a gui on the ocz forums that monitors the amount of
data written to the fs since the last trim and reminds you to run
another pass.  The script can trim the fs while it is online by creating
a large temporary file to occupy the remaining free space, mapping the
blocks it is allocated, and trimming those.


