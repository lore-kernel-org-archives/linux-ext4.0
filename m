From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: Problem with fsstress on powerpc
Date: Wed, 9 Apr 2008 12:33:41 +0400
Message-ID: <20080409083341.GC944@dmon-lap.sw.ru>
References: <20080408152455.GA10827@skywalker> <20080409074457.GB944@dmon-lap.sw.ru> <20080409082115.GA8238@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:41173 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYDIIlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 04:41:00 -0400
Content-Disposition: inline
In-Reply-To: <20080409082115.GA8238@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13:51 Wed 09 Apr     , Aneesh Kumar K.V wrote:
> On Wed, Apr 09, 2008 at 11:44:57AM +0400, Dmitri Monakhov wrote:
> > On 20:54 Tue 08 Apr     , Aneesh Kumar K.V wrote:
> > > Hi All,
> > > 
> > > Test case: fsstress with fallocate test case added.
> > This may happens because of direct write.
> > Please add  exact fsstess command and options.
> > > 
> 
> fsstress -c -n1000 -p1000  -d /mnt/tmp/
> 
> What i found was also related. The file which had errors had the below
> operations on them.
> 
> 82/901: dread d16/d20/d22/d2d/d63/d68/d9a/f93 [622592,53248] 0
> 82/939: dwrite d16/d20/d22/d2d/d63/d68/d9a/f93 [1093632,77824] 28
> 
> 
> 9/863: fallocate d1/d2d/d32/d8f/d97/d108/d9b/ffb [2041,75851] 28
> 
> 
> 18/733: fallocate d9/ddd/f86 [481025,18486] 0
> 18/735: dwrite d9/ddd/f86 [679936,36864] 0
> 18/764: dread d9/ddd/f86 [53248,8192] 0
> 18/910: dwrite d9/ddd/f86 [1454080,4096] 28
> 18/999: dwrite d9/ddd/f86 [1798144,61440] 28
> 
> 
> But what would happen during direct write that cause this ?
Ohh it is long live bug in direct-io error handling logic:
http://lkml.org/lkml/2006/12/18/103
So IMHO it is beter to disable direct-io writes in your case.
> 
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
