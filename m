From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -v3] ext4: refactor duplicated block placement code
Date: Tue, 28 Jun 2011 09:45:28 -0500
Message-ID: <4E09E908.7020106@redhat.com>
References: <4E08EA6F.4010102@redhat.com> <1309269909-15341-1-git-send-email-tytso@mit.edu> <4E09E1C8.9020107@redhat.com> <20110628144449.GK2729@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab1F1Opb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 10:45:31 -0400
In-Reply-To: <20110628144449.GK2729@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/28/11 9:44 AM, Ted Ts'o wrote:
> On Tue, Jun 28, 2011 at 09:14:32AM -0500, Eric Sandeen wrote:
>> On 6/28/11 9:05 AM, Theodore Ts'o wrote:
>>> From: "Theodore Ts'o" <tytso@mit.edu>
>>
>> I kind of wish you'd keep me on the From: even if you did
>> move the change to a new file.
> 
> No worries, you are still the author in the git commit.
> 
> The From that you saw was becasue because I edited the output of
> git-format-patch before I used git send-email, forgetting that git
> send-email would fix up the from field and move the original From
> field into the budy of the message.
> 
> 					- Ted

Thanks, just checking; when I import something with From: into guilt,
that sets the author.

-Eric
