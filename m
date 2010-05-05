From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] New testcase to check if fallocate respects	RLIMIT_FSIZE
 or not
Date: Wed, 05 May 2010 10:50:07 -0500
Message-ID: <4BE193AF.3070505@redhat.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de> <201004291014.07194.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org> <20100501070426.GA9562@amitarora.in.ibm.com> <20100501101846.GA3769@infradead.org> <20100503083135.GC13756@amitarora.in.ibm.com> <4BE08718.5040608@redhat.com> <20100505075556.GA5142@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
	Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0EEPvD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 May 2010 11:51:03 -0400
In-Reply-To: <20100505075556.GA5142@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/05/2010 02:55 AM, Amit K. Arora wrote:
> On Tue, May 04, 2010 at 03:44:08PM -0500, Eric Sandeen wrote:
>> Amit K. Arora wrote:
>>> Here is the new testcase.
>> Thanks!  A few comments...
> Thanks for the review!

Sure thing - looks good, I'll merge it after a retest if it all goes
well.  :)

-Eric

