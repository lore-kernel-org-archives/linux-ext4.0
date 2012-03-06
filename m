From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Tue, 06 Mar 2012 13:44:28 -0500
Message-ID: <yq1mx7tk1rn.fsf@sermon.lab.mkp.net>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
	<4F5135F0.6090100@redhat.com> <20120302231131.GE22215@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50385 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab2CFSof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 13:44:35 -0500
In-Reply-To: <20120302231131.GE22215@thunk.org> (Ted Ts'o's message of "Fri, 2
	Mar 2012 18:11:31 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> As far as the /sys/block/XXX/queue/* framework, certainly.  It's
Ted> not clear, however, whether or not we should use entirely new
Ted> parameters, or try to reuse the existing parameters.  For example,
Ted> would it be better to use optimal_io_size for the flash page size,
Ted> or the erase block size?

If we were to use the existing fields we'd probably set min_io to the
flash page size and optimal_io to the erase block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
