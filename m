From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Sat, 26 Jan 2008 20:56:24 +0900
Message-ID: <2f11576a0801260356tfbf3078w5ff98e8909e07b6c@mail.gmail.com>
References: <9Mo9w-7Ws-23@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it>
	 <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
	 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist>
	 <20080124234037.GJ15858@mit.edu> <1201220742.7557.10.camel@localhost>
	 <20080125110942.GX18433@webber.adilger.int>
	 <1201308912.7784.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, "Adrian Bunk" <bunk@kernel.org>,
	"Bodo Eggert" <7eggert@gmx.de>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
	"David Chinner" <dgc@sgi.com>,
	"Valerie Henson" <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Ric Wheeler" <ric@emc.com>
To: "Zan Lynx" <zlynx@acm.org>, "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1201308912.7784.6.camel@localhost>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The commentary on the mem_notify threads claimed that the signal is
> easily provided by setting up the file handle for SIGIO.

BTW:
Of cource, you can receive any signal instead SIGIO by use fcntl(F_SETSIG)  :-)
