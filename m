From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 19:45:32 -0700
Message-ID: <1285469132.6115.162.camel@Joe-Laptop>
References: <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop> <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop> <20100926010410.GC19690@thunk.org>
	 <1285464746.6115.108.camel@Joe-Laptop> <20100926015328.GI19690@thunk.org>
	 <1285466591.6115.117.camel@Joe-Laptop> <20100926021030.GJ19690@thunk.org>
	 <20100926022137.GK19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100926022137.GK19690@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2010-09-25 at 22:21 -0400, Ted Ts'o wrote:
> P.S.  This is also completely insane:
>     --git-min-percent => minimum percentage of commits required (default: 5)
> Anyone who has 5% of the commits should be considered a maintainer?!?

Probably --git-min-signatures=1 isn't high enough either.

I have no issue changing those to whatever is appropriate.

I believe the only person to comment on the % before
was Mark Brown, who might have suggested that number.

There've always been tradeoffs between activity on the file,
direct maintainership and reasonable accuracy of patterns.

Today, patterns are mostly reasonable, except for arch/arm/.
