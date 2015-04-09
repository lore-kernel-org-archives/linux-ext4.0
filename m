From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: WARNING: CPU: 10 PID: 23340 at fs/block_dev.c
Date: Thu, 9 Apr 2015 11:17:36 -0400
Message-ID: <20150409151736.GA31268@thunk.org>
References: <55268959.6040507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55268959.6040507@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 09, 2015 at 10:14:49AM -0400, Sasha Levin wrote:
> Hi all,
> 
> I was running xfstests on the latest -next kernel directed at an ext4 mount,
> and saw the following on the generic/019 test:

Hi Sasha,

This isn't a test I normally run; is it a test you've run in the past?
If so, do you know when it first started failing for you?

Thanks,

						- Ted
