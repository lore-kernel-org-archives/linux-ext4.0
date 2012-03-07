From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Wed, 07 Mar 2012 00:02:19 -0500
Message-ID: <yq1k42xhulg.fsf@sermon.lab.mkp.net>
References: <20120305125029.GA5121@gmail.com> <20120307005130.GH3592@dastard>
	<A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28048 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2CGFCm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 00:02:42 -0500
In-Reply-To: <A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca> (Andreas
	Dilger's message of "Wed, 7 Mar 2012 12:14:43 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Andreas" == Andreas Dilger <aedilger@gmail.com> writes:

Andreas> This proposal definitely needs to have some clear explanation
Andreas> of how the flags are intended to be used by applications, and
Andreas> why they will help filesystems to improve allocation. 

This goes a bit deeper than just filesystem block allocation strategy.

With SMR drives lurking on the horizon it is becoming increasingly
important for us to classify anticipated future access patterns as we
send I/Os out to storage. We'll need something much smarter than just
REQ_META for these devices. Tiered storage arrays and tiered flash also
benefit from this information.

There's lots of work going on in the standards space in this department
right now and I was hoping we could spend some time discussing the
current proposals in one of the plenary sessions at LSF. Ideally we'd
tie fadvise() and any filesystem internal knowledge into appropriate
storage hints at the bottom of the stack.

-- 
Martin K. Petersen	Oracle Linux Engineering
