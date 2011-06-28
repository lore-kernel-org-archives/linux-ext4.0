From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v3] ext4: refactor duplicated block placement code
Date: Tue, 28 Jun 2011 10:44:49 -0400
Message-ID: <20110628144449.GK2729@thunk.org>
References: <4E08EA6F.4010102@redhat.com>
 <1309269909-15341-1-git-send-email-tytso@mit.edu>
 <4E09E1C8.9020107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48207 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758365Ab1F1Oou (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 10:44:50 -0400
Content-Disposition: inline
In-Reply-To: <4E09E1C8.9020107@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 09:14:32AM -0500, Eric Sandeen wrote:
> On 6/28/11 9:05 AM, Theodore Ts'o wrote:
> > From: "Theodore Ts'o" <tytso@mit.edu>
> 
> I kind of wish you'd keep me on the From: even if you did
> move the change to a new file.

No worries, you are still the author in the git commit.

The From that you saw was becasue because I edited the output of
git-format-patch before I used git send-email, forgetting that git
send-email would fix up the from field and move the original From
field into the budy of the message.

					- Ted
