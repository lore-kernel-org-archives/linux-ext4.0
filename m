From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Thu, 28 Aug 2008 10:38:39 -0400
Message-ID: <48B6B86F.5060106@redhat.com>
References: <20080827210636.GC26987@mit.edu> <1219871676-18456-1-git-send-email-tytso@mit.edu> <1219871676-18456-2-git-send-email-tytso@mit.edu> <1219917321.3591.79.camel@frecb007923.frec.bull.fr> <20080828133449.GG26987@mit.edu> <48B6AACE.6060103@redhat.com> <20080828143648.GJ26987@mit.edu>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYH1OlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 10:41:07 -0400
In-Reply-To: <20080828143648.GJ26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Aug 28, 2008 at 09:40:30AM -0400, Ric Wheeler wrote:
>   
>> I can try and test this with my fsync() heavy fs_mark run...
>>
>>     
>
> Given [1] I have no doubt that you should see a difference between
> mke2fs from e2fsprogs 1.41.0 (which will allocate the journal at the
> beginning of the filesystem) and the latest tip of e2fsprogs.
>
> It would be interesting to see how measurable the difference is,
> though.  I'd recommend doing "mke2fs -t ext4dev" using both versions
> of mke2fs, and seeing how much the difference it makes.
>
> [1] http://www.usenix.org/events/usenix05/tech/general/full_papers/prabhakaran/prabhakaran_html/main.html#fig-journal-location-withinfs-fix
>
> 							- Ted
>
>   

I was thinking of trying this on a much larger disk (1TB) - the article 
reports on a 4GB partition which is pretty tiny,

ric

