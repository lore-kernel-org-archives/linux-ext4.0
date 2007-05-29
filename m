From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Tue, 29 May 2007 15:56:44 -0500
Message-ID: <465C938C.3060101@redhat.com>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov> <465C75A8.5080506@redhat.com> <20070529205141.GB5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Brian D. Behlendorf" <behlendorf1@llnl.gov>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXE2U4z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 16:56:55 -0400
In-Reply-To: <20070529205141.GB5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On May 29, 2007  13:49 -0500, Eric Sandeen wrote:
>> Brian D. Behlendorf wrote:
>>> Lawrence Livermore National Labs recently ran the source code
>>> analysis tool Coverity over the e2fsprogs-1.39 source to see 
>>> if it would identify any significant bugs.  The analysis
>>> turned up 38 mostly minor issues which are enumerated here
>>> with patches.  We went through and resolved these issues
>>> but would love to see these mostly minor changes reviewed
>>> and commited upstream.
>> Did cid-34.diff get lost?
> 
> I still have it in my "apply atop 1.39-WIP" series, so it appears not
> to have made it into Ted's repo.  I'm including the patch again for
> posterity.

Thanks Andreas - near as I can tell, it never made it to the list.

-Eric
