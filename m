From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 00:35:21 +0100
Message-ID: <20080520233521.GK27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <8763tbcrbo.fsf@basil.nowhere.org> <20080519004325.GC8335@mit.edu> <4830E60A.2010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4830E60A.2010809@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> I'll propose that very close to 0% of users will ever report "having
> barriers off seems to have corrupted my disk on power loss!" even if
> that's exactly what happened.  And it'd be very tricky to identify in a
> post-mortem.

Ooh.

Might it be possible for fsck to identify certain problems as likely
caused by power loss in misordered writes?

If metadata sectors had an update generation number, to be compared
with journal entries, perhaps that would be more feasible.

-- Jamie
