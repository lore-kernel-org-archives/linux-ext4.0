From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Date: Thu, 18 Oct 2012 16:13:58 -0600
Message-ID: <50807F26.5070106@genband.com>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk> <20121012133044.GA10115@dhcp22.suse.cz> <E6EF14955C67D6CA58918872@nimrod.local> <20121012145838.GD22083@dhcp22.suse.cz> <3D1C85A52BB960B79E37AC30@nimrod.local> <20121018212845.GB17646@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Bligh <alex@alex.org.uk>, Michal Hocko <mhocko@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121018212845.GB17646@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/18/2012 03:28 PM, Jan Kara wrote:

>    Yeah, ionice has its limitations. The problem is that all buffered
> writes happen just into memory (so completely independently of ionice
> settings). Subsequent writing of dirty memory to disk happens using flusher
> thread which is a kernel process and it doesn't know anything about IO
> priority set for task which created the file. If you wrote the file with
> oflag=direct or oflag=sync you would see that ionice works as expected.

Has anyone looked at storing the ionice value with the buffered write 
request such that the actual writes to disk could be sorted by priority 
and done with the ionice level of the original caller?

Chris
