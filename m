From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] blkid: return cached info on either EPERM or
 EACCESS
Date: Tue, 27 May 2008 15:40:51 -0500
Message-ID: <483C71D3.4050309@redhat.com>
References: <483C60C4.6020509@redhat.com> <20080527203730.GM7515@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbYE0Uky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2008 16:40:54 -0400
In-Reply-To: <20080527203730.GM7515@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, May 27, 2008 at 02:28:04PM -0500, Eric Sandeen wrote:
>> This is for RH bug #448591: blkid command does not work for unprivileged users
>>
>> commit 838f133c72a583eae67414368e46ee0303e0a51f made it so that
>> any error except EPERM would flush cached filesystem info, but
>> if I run blkid as an unprivileged user on F9, I get EACCES not
>> EPERM; I think that in this case, as well, we should continue.
> 
> This fix is already in e2fsprogs 1.10.....  what version were you
> patching against?
> 
> 							- Ted

Oh, sorry.. a slightly earlier version.  :)  I just missed the fix.
Sorry for the noise...

-Eric
