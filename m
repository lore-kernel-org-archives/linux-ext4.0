From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Tue, 29 May 2007 13:49:12 -0500
Message-ID: <465C75A8.5080506@redhat.com>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbXE2StO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 14:49:14 -0400
In-Reply-To: <200702100211.l1A2BTRb007321@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Brian D. Behlendorf wrote:
> Lawrence Livermore National Labs recently ran the source code
> analysis tool Coverity over the e2fsprogs-1.39 source to see 
> if it would identify any significant bugs.  The analysis
> turned up 38 mostly minor issues which are enumerated here
> with patches.  We went through and resolved these issues
> but would love to see these mostly minor changes reviewed
> and commited upstream.

Did cid-34.diff get lost?

-Eric
