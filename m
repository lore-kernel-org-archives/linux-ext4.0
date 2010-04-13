From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: No space left on device after many files creation
Date: Tue, 13 Apr 2010 10:34:15 -0500
Message-ID: <4BC48EF7.5030702@redhat.com>
References: <4BC38EB9.8080501@gmail.com> <4BC39098.4030704@redhat.com> <4BC39762.9080406@gmail.com> <4BC39805.7090807@redhat.com> <20100412224429.GN1849@thunk.org> <4BC410AB.1030607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: cy6erGn0m <cy6ergn0m@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0DMPeS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Apr 2010 11:34:18 -0400
In-Reply-To: <4BC410AB.1030607@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/13/2010 01:35 AM, cy6erGn0m wrote:

> I know that filesystems is not targeted for this usecase, but inodes
> limit looks strange.. why they are can't be allocated dinamically? Can I

ext2/3/4 don't allocate dynamically; there was some talk of trying to
find a way to do this but it's not really very high on the list at all.

xfs does do this, not sure about other filesystems.

> enlarge this limit on the fly?

No, but since you know your usecase, you can change it at mkfs time to
match what you need.

-Eric
