From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Mon, 27 Sep 2010 08:52:38 -0500
Message-ID: <4CA0A1A6.2050707@redhat.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com> <20100925235459.GA5299@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Tracey Dent <tdent48227@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-ker
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0I0Nww (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 09:52:52 -0400
In-Reply-To: <20100925235459.GA5299@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Sat, Sep 25, 2010 at 02:31:52PM -0400, Tracey Dent wrote:
>> From: Tracey Dent <Tdent48227@gmail.com>
>>
>> Found and corrected indent issue using checkpatch.pl
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> 
> Patches that fix whitespace issues aren't really worthwhile.  They
> tend to cause extra work for the me as the maintainer, since it means
> that patches that others send me end up failing due to whitespace
> issues, which then have to be manually fixed up.
> 

I second that sentiment, despite being guilty of similar patches
to other subsystems in the distant past ;)  I've seen the light.

I would prefer that these not get merged.

-Eric
