From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 17/25] mke2fs: Do not let -t or -T be specified more than
 once
Date: Fri, 16 Sep 2011 19:49:17 -0500
Message-ID: <4E73EE8D.9070705@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com> <1316206180-6375-18-git-send-email-sandeen@redhat.com> <20110916225720.GT16246@thunk.org> <20110916225754.GU16246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1IQAtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 20:49:19 -0400
In-Reply-To: <20110916225754.GU16246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/16/11 5:57 PM, Ted Ts'o wrote:
> On Fri, Sep 16, 2011 at 06:57:20PM -0400, Ted Ts'o wrote:
>> On Fri, Sep 16, 2011 at 03:49:32PM -0500, Eric Sandeen wrote:
>>> In addition to not making since, it causes a memory leak
>>> when fs_type gets overwritten.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Applied, with whitespace cleanups.
> 
> Oh, and s/since/sense/
> 
> 					- Ted

whoops thanks.

Usually my English is ok, sorry!  ;)
