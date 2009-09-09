From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 09 Sep 2009 12:21:21 -0500
Message-ID: <4AA7E411.7070005@redhat.com>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de> <4AA7BE69.7070406@redhat.com> <20090909172015.GA1980@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZIIRVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 13:21:33 -0400
In-Reply-To: <20090909172015.GA1980@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus Trippelsdorf wrote:
> On Wed, Sep 09, 2009 at 09:40:41AM -0500, Eric Sandeen wrote:
>> Markus Trippelsdorf wrote:

...

>>> The bug is very simple to reproduce here. Just run rsnapshot several
>>> times per day and you will eventually hit the problem.
>> Could you provide a bzip2'd e2image -r of a corrupted filesystem for 
>> analysis?
> 
> OK I've uploaded the file (~80 MB):
> http://www.2shared.com/file/7681344/d19d7154/disc_e2image.html
> 
> Hope it helps.

Thanks, can't guarantee that the post-mortem will lead to the anwer but 
it's worth a look.

-Eric
