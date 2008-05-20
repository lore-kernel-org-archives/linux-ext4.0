From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 15:58:13 +0100
Message-ID: <20080520145813.GE16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <4830E60A.2010809@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200805191316.27551.chris.mason@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason wrote:

> Everyone thinks the barriers are slow because we also think running
> without barriers is mostly safe.

+1.  There really hasn't been much effort at optimising barriers.

> Making them faster in general may be possible, but they are somewhat
> pushed off to the side right now because so few people are running them.

+1 too.

-- Jamie
