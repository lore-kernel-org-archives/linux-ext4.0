From: Michael Rubin <mrubin@google.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 11 Feb 2011 10:44:25 -0800
Message-ID: <AANLkTimebOEZxL6dJxDg19C-XTXgnZpORXjStn+1=cO6@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com>
 <20110204130313.GB4104@quack.suse.cz> <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca>
 <20110207161933.GB5337@quack.suse.cz> <946A4527-3A1C-4EC5-BEAC-4E47F3CFDF01@dilger.ca>
 <20110211111658.GA5187@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	ext4 List <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:56773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab1BKSor (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Feb 2011 13:44:47 -0500
Received: from kpbe11.cbf.corp.google.com (kpbe11.cbf.corp.google.com [172.25.105.75])
	by smtp-out.google.com with ESMTP id p1BIikD4017064
	for <linux-ext4@vger.kernel.org>; Fri, 11 Feb 2011 10:44:46 -0800
Received: from gxk28 (gxk28.prod.google.com [10.202.11.28])
	by kpbe11.cbf.corp.google.com with ESMTP id p1BIij29014975
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Feb 2011 10:44:46 -0800
Received: by gxk28 with SMTP id 28so1368162gxk.18
        for <linux-ext4@vger.kernel.org>; Fri, 11 Feb 2011 10:44:45 -0800 (PST)
In-Reply-To: <20110211111658.GA5187@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just as an aside, we just upgraded in place a large number of ext2
file systems to ext4. The process completed very smoothly and created
a performance boost for almost every workload we had.

I think keeping ext3 around is really convenient to compare against
ext4 as it becomes more mature, but outside of its academic use I
don't see any good reason to keep it around. With such an easy
migration path for users (mount as ext4 in place) I think an "end of
life" plan should not be that complicated and encouraged.

mrubin
