From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Fri, 5 Jun 2009 14:51:27 +0300
Message-ID: <20090605115127.GF28764@smart.research.nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com> <4A28FC8F.5020802@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
To: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753201AbZFELwD@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A28FC8F.5020802@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 05, 2009 at 01:07:59PM +0200, Bityutskiy Artem (Nokia-D/Helsinki) wrote:
> Kay Sievers wrote:
> > And I don't think we want several event sources for the same thing,
> > uevents _and_ pollable sysfs files.
> > 
> > We already raise events on /proc/self/mountinfo when the mount tree
> > changes, I guess that's where fs specific stuff belongs, and it will
> > work with all kind of filesystem setups, regardless of the devices
> > below it. This is also the established interface for flags and options
> > and the current state of the filesystem, and does not mix filesystem
> > options into block device interfaces.
> > 
> > /proc/self/mountinfo could also work properly with namespaces which
> > might have different meaning for a device in a different namespace.
> 
> Well, Denis suggests /sys/fs instead. But how would we pass stuff like
> error code via /proc/self/mountinfo? And what if later some one wants
> to provide user-space stuff like bogus inode number? 

This is doable, e.g. in the form of optional fields "tag[:value]"
(field 7, Documentation/filesystems/proc.txti for mountinfo).

Kay, sorry I didn't answer to your email separately. I tried to summarize
and address all the posted comments/critiques in a single email earlier 
in this thread.
http://marc.info/?l=linux-kernel&m=124412575828015&w=2

But is using procfs generally a good idea ? Last several years all a lot of
stuff moved out from procfs into sysfs. Not to forget what procfs is
originally meant for: storing the proceses related information.

/proc/self/mountinfo solution:
pros:
- existing solution
cons:
- polling only
- dedicated userspace tool to poll/parse/act
- additional parsing overhead and event filtering (mountinfo changes for many
  reasons)
- probably this info does not belong to procfs

/sys/fs/<fs>/<volume>/{attributes,..} solution:
pros:
- nice hierarchy reflecting structure of entities in the kernel
- extensible (other errors, conditions, events can be reflected) 
- no parsing: dedicated file for each attribute
- uevent interface with existing userspace tool (udev); 
  (polling is still possible)
- /sys/fs seems to be a perfect fit for the purpose judging by ext4 example
cons:
- uevent interface is unneeded extra(?); can be made optional, per attribute
- ...

Denis
