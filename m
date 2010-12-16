From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Thu, 16 Dec 2010 13:22:20 +0100
Message-ID: <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 9, 2010 at 1:03 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Since the introduction of ext4, some apps/users have had issues with
> file corruption after a system crash. It's not a bug in the FS AFAIK
> and it's not exclusive to ext4.
> Writing a temp file, fsync, rename is often proposed. However, the
> durable aspect of fsync isn't always required and this way has other
> issues.
> What is the recommended way for atomic non-durable (complete) file writes?
>
> I'm also wondering why FSs commit after open/truncate but before
> write/close. AFAIK this isn't necessary and thus suboptimal.

Somebody?

Olaf
