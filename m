From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 14:24:32 -0400
Message-ID: <20150923182432.GH3318@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923172535.GC25218@ret.masoncoding.com>
 <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
 <20150923175337.GD25218@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <clm@fb.com>, Artem Bityutskiy <dedekind1@gmail.com>,
	linux-ext4@vger.kernel.org, hannes@cmpxchg.org, axboe@kernel.dk,
	Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org,
	adilger.kernel@dilger.ca, kernel-team@fb.com,
	linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150923175337.GD25218@ret.masoncoding.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Artem,

Can you (or someone on the cgroups list, perhaps) give more details
about how Fedora 22 sets up groups?

Unfortunately apparently no one has gotten an official Fedora image
for Google Compute Engine so it's a bit of a pain for me to reproduce
the problem.  (I suppose I could use AWS, but all of my test
infrastructure uses GCE, and I'd really rather not have to install a
Java Runtime on my laptop. :-)

Or can you reproduce this problem on Debian Jessie?

Thanks,

					- Ted
