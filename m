From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Fri, 4 Nov 2016 20:00:52 -0400
Message-ID: <20161105000052.54dmfdp5sgiqq6wo@thunk.org>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
 <CAEuANoLdZ0STmhp+1voS9K6+Ndkb6zfSWEcc0_thUtDjS8NPwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Daniel Rosenberg <drosen@google.com>, guy@linux.com
To: Jeremy Allison <jra@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51024 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbcKEAA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 20:00:57 -0400
Content-Disposition: inline
In-Reply-To: <CAEuANoLdZ0STmhp+1voS9K6+Ndkb6zfSWEcc0_thUtDjS8NPwg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04, 2016 at 04:28:05PM -0700, Jeremy Allison wrote:
> I don't suppose ext4 has a negative cache for lookups ? That would
> certainly help the linear search case on lookup miss.

The dcache caches negative results, so as long as the lookup miss is
for the same non-existing file name, that's not a problem.

The issue will be if someone is using Makefile with default rules,
say, and Makefile is checking for foo.y, foo.l, foo.C, etc. for each
object file, there could be a fairly large number of failed lookups
that might require O(n) lookups.  Eventually all of these will be
cached, yes, but it could be a large number of negative dentry caches.

However, I'm not sure I care; no self-respecting programmer should be
using a case-insensitive file system, so in practice, I'm not sure it
matters all that much....

					- Ted
