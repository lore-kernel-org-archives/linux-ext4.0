From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: Group meta-data blocks together.
Date: Tue, 29 Apr 2008 15:19:35 -0500
Message-ID: <481782D7.9050102@redhat.com>
References: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbYD2UqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2008 16:46:21 -0400
In-Reply-To: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Hi Eric,
> 
> I haven't yet tested this. Let me know what you think.
> 
> -aneesh

I'll look over it when I get a chance; I did do a quick test with my RM
scenario, and it came in about 1s faster than stock (5s vs. 6s)  :)

http://people.redhat.com/esandeen/rm_test/ext4_aneesh_rm.png

-Eric
