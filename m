From: Chris Samuel <chris@csamuel.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Wed, 01 Aug 2012 16:36:22 +1000
Message-ID: <5018CE66.6050609@csamuel.org>
References: <201207222135.11159.Martin@lichtvoll.de> <20120202124241.GW16796@shiny> <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120722204428.GC3925@merlins.org> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <20120727110835.GA6933@shiny> <20120727184238.GA6713@merlins.org> <20120801060135.GH12695@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@fusionio.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120801060135.GH12695@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/08/12 16:01, Marc MERLIN wrote:

> Third, A freshly made ntfs filesystem through fuse is actually FASTER!

Could it be that Samsungs FTL has optimisations in it for NTFS ?

A horrible thought, but not impossible..

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
