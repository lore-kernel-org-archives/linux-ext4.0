From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Mon, 05 Nov 2007 11:39:11 -0600
Message-ID: <472F553F.2090404@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com> <472F54EE.9030904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz.tomas@gmail.com>,
	Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXKERjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 12:39:22 -0500
In-Reply-To: <472F54EE.9030904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Alex Tomas wrote:
>> thanks for the data. the attached patch should fix couple issues:
>> broken history output and policy in that smaller usable chunk to
>> be used. can you give it a spin, please?
> 
> Hi Alex -
> 
> This looks *much* better:

(nb: that's running w/ both of the patches you sent on this thread)

-Eric
