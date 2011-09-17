From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 09/25] uuidd: Add missing break to option case statement
Date: Fri, 16 Sep 2011 19:47:48 -0500
Message-ID: <4E73EE34.4050105@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com> <1316206180-6375-10-git-send-email-sandeen@redhat.com> <20110916225417.GL16246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990Ab1IQArv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 20:47:51 -0400
In-Reply-To: <20110916225417.GL16246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/16/11 5:54 PM, Ted Ts'o wrote:
> On Fri, Sep 16, 2011 at 03:49:24PM -0500, Eric Sandeen wrote:
>> Specifying the "-n" option to uuidd would incorrectly
>> fall through to the "-p" case, and assign that number to
>> the pidfile_path.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Applied, thanks.
> 
> Can you do me a favor and make sure this gets fixed in util-linux-ng
> as well?

sure thing

-eric

> 	 			- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

