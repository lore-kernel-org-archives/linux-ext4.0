From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH][ext4-next] ext4: ensure error return ret is zero on
 successful return
Date: Fri, 23 Jun 2017 10:04:32 -0700
Message-ID: <CAAeU0aMtbRBN80fhPza4QS-77Mn=KAPO8STt__tq8UjtQuuk2Q@mail.gmail.com>
References: <20170623145840.26779-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170623145840.26779-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 7:58 AM, Colin King <colin.king@canonical.com> wrote:
> The error return ret is not set on a successful return path and
> so it returns a garbage value. Ensure it is is set to zero on
> a successful return.
Thanks for catching this bug!

Reviewed-by: Tahsin Erdogan <tahsin@google.com>
