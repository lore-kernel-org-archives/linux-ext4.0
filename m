From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 00:44:17 +0100
Message-ID: <20080520234417.GL27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <200805172048.34455.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:35102 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYETXoj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 19:44:39 -0400
Content-Disposition: inline
In-Reply-To: <200805172048.34455.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason wrote:
> write log blocks
> flush #1
> write commit block
> flush #2
> write metadata blocks
> 
> I'd agree with Ted, there's a fairly small chance of things get reordered 
> around flush #1.

Except when it crosses an MD disk boundary.  Then it's really likely.

We could also ask if there's _any_ possibility, when they are a merged
single I/O, of them not getting written in the expected order?
What about when FUA is set, does that imply any order?

But it's all moot: Checksumming is the way forward here, no doubt.
Checksumming makes the multi-sector write "atomic or corrupt".  That's
the same expectation as a commit sector provides by itself, but
generalised to the whole journal entry.

-- Jamie
