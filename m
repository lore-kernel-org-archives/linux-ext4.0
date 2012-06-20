From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 14:35:39 -0500
Message-ID: <4FE2260B.6090602@redhat.com>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Norbert Preining <preining@logic.at>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab2FTTfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 15:35:54 -0400
In-Reply-To: <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/19/12 10:57 PM, Eric Sandeen wrote:
> On Jun 19, 2012, at 10:38 PM, Norbert Preining <preining@logic.at> wrote:
> 
>> Hi Ted, hi Eric,
>>
>> thanks for the answers, here some remarks.
>>
> ...
> 
>> On Di, 19 Jun 2012, Eric Sandeen wrote:
>>> As Ted said, the targets might be far-flung.  If you do /bin/ls -l instead
>>> of maybe an aliased ls which stats everything to make pretty colors,
>>> is that faster?
>>
>> Might be the problem, but I saw the same with a program doing
>> opendir readdir etc, so no allias or external program involved.
>>
> Of course ls -l must stat anyway.  I shouldn't compose emails so late.  :). 

Oh, but Zach Brown reminds me that if we stat the entries in getdents/hash
order, it's roughly random w.r.t. disk location.  Newer utils will sort into
inode order, I think(?)  Might be interesting to strace the ls -l and see
if it's doing it in inode order, or not.

-Eric

