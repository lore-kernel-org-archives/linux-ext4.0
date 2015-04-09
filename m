From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: ext4: WARNING: CPU: 10 PID: 23340 at fs/block_dev.c
Date: Thu, 09 Apr 2015 16:49:31 -0400
Message-ID: <5526E5DB.1020602@oracle.com>
References: <55268959.6040507@oracle.com> <20150409151736.GA31268@thunk.org> <55269891.3050709@oracle.com> <20150409202736.GA13705@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150409202736.GA13705@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/09/2015 04:27 PM, Theodore Ts'o wrote:
> I tried manually running generic/019, and even though I have
> CONFIG_FAIL_MAKE_REQUEST defined, /sys/kernel/debug/fail_make_request
> isn't present, and so the test complains that I haven't compiled it
> into my kernel --- even though /proc/config.gz confirms that it is
> enabled.
> 
> Is there anything special I have to do to get generic/019 to run?

The only thing I can think of is that maybe debugfs isn't mounted at
all? Do you see anything else in /sys/kernel/debug/?


Thanks,
Sasha
