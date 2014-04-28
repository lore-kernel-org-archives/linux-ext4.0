From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5/7] mke2fs: proceed if the user doesn't type anything
 after 5 seconds
Date: Mon, 28 Apr 2014 10:36:52 -0500
Message-ID: <535E7594.2030203@redhat.com>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-5-git-send-email-tytso@mit.edu> <535E74D4.4050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbaD1Pg4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 11:36:56 -0400
In-Reply-To: <535E74D4.4050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/28/14, 10:33 AM, Eric Sandeen wrote:
> On 4/26/14, 7:00 PM, Theodore Ts'o wrote:
>> If mke2fs needs to ask the user for permission, and the user doesn't
>> type anything for five seconds, proceed as if the user had said yes.
>>
>> This will allow us to add more stringent checks without breaking
>> existing scripts (much).
> 
> Hm, this sounds a little dangerous - "-F" overrides a lot.

To mitigate the danger, it might be better to keep the default,
but allow setting a non-infinite delay in environments which
require it.

-Eric
