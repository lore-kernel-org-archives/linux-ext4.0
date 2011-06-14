From: Norbert Preining <preining@logic.at>
Subject: Re: another ext3 kernel BUG
Date: Tue, 14 Jun 2011 13:03:13 +0900
Message-ID: <20110614040313.GA6618@gamma.logic.tuwien.ac.at>
References: <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DF6D644.3010109@redhat.com> <20110614032111.GA5392@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi everyone,

On Mo, 13 Jun 2011, Dave Jones wrote:
> we've been getting a lot of bug reports in Fedora that have the vbox module
> loaded that manifest in various ways that look like it's corrupting kernel data
> structures. (Usually it scribbles over some linked list, and the CONFIG_LIST_DEBUG
> stuff catches it).

Ahh, ok. I thought that if the modules are loaded but NOT in use,
in the sense no vbox is running, then they cannot do much harm.
At the end it was always on heavy IO load without any vbox interaction.

But I will recompile with CONFIG_LIST_DEBUG and see what comes out.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WHASSET (n.)
A business card in you wallet belonging to someone whom you have no
recollection of meeting.
			--- Douglas Adams, The Meaning of Liff
