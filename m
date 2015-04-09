From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: ext4: WARNING: CPU: 10 PID: 23340 at fs/block_dev.c
Date: Thu, 09 Apr 2015 11:19:45 -0400
Message-ID: <55269891.3050709@oracle.com>
References: <55268959.6040507@oracle.com> <20150409151736.GA31268@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150409151736.GA31268@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/09/2015 11:17 AM, Theodore Ts'o wrote:
> On Thu, Apr 09, 2015 at 10:14:49AM -0400, Sasha Levin wrote:
>> > Hi all,
>> > 
>> > I was running xfstests on the latest -next kernel directed at an ext4 mount,
>> > and saw the following on the generic/019 test:
> Hi Sasha,
> 
> This isn't a test I normally run; is it a test you've run in the past?
> If so, do you know when it first started failing for you?

Nope, I just got new servers to play with and decided to try xfstests.

I can try bisection if it doesn't sound familiar, but since it's metal
servers it'll take a while.


Thanks,
Sasha
